# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic to add an attachment collection
    # to a participatory space.
    class CreateAttachmentCollection < Decidim::Command
      delegate :current_user, to: :form
      # Public: Initializes the command.
      #
      # form - A form object with the params.
      # collection_for - The ActiveRecord::Base that will hold the collection
      def initialize(form, collection_for)
        @form = form
        @collection_for = collection_for
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form was not valid and we could not proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        create_attachment_collection
        broadcast(:ok)
      end

      private

      attr_reader :form

      def create_attachment_collection
        Decidim.traceability.create!(
          AttachmentCollection,
          current_user,
          attributes
        )
      end

      def attributes
        {
          name: form.name,
          weight: form.weight,
          description: form.description,
          collection_for: @collection_for
        }
      end
    end
  end
end
