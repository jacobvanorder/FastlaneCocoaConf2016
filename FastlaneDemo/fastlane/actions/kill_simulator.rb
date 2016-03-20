module Fastlane
  module Actions
    module SharedValues
      KILL_SIMULATOR_CUSTOM_VALUE = :KILL_SIMULATOR_CUSTOM_VALUE
    end

    class KillSimulatorAction < Action
      def self.run(params)
        sh 'killall "Simulator"'
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Kills the simulator"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "Kills the simulator on Xcode 7"
      end

      def self.available_options
      end

      def self.output
      end

      def self.return_value
      end

      def self.authors
        "@jacobvo"
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
