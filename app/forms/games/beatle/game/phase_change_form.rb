module Games
  module Beatle
    class Game
      class PhaseChangeForm
        include ActiveModel::Model
        include PhaseValidations

        validates :phase, presence: true
        validate :validate_phase_changed
        validate :validate_phase_transition_allowed
        validate :validate_phase_requirements

        def initialize(game:, params: {})
          @game = game
          @params = params
        end

        def save
          return unless valid?

          ApplicationRecord.transaction do
            PhasePreparations.new(game:, phase:).prepare!
            game.update!(phase:)
          end && true
        end

        def phase
          params[:phase]
        end

        def model_name
          ActiveModel::Name.new(self, nil, "Game")
        end

        private

        attr_reader :game, :params

        def validate_phase_changed
          return if game.phase.to_sym != phase.to_sym

          errors.add(:phase_not_changed)
        end

        def validate_phase_transition_allowed
          return if game.transition_allowed?(to_phase: phase)

          errors.add(:base, :transition_not_allowed)
        end

        def validate_phase_requirements
          validate_phase_requirements_for(phase)
        end
      end
    end
  end
end
