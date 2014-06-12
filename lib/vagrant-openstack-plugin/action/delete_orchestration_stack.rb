require "fog"
require "log4r"

module VagrantPlugins
  module OpenStack
    module Action
      class DeleteOrchestrationStack

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new(
            "vagrant_openstack::action::delete_orchestration_stack")
        end

        def call(env)
          # Get the config.
          config = env[:machine].provider_config

          # Load IDs for orchestration stacks created by vagrant and this
          # project.
          created_stacks_fname = env[:machine].data_dir + 'orchestration_stacks'

          # Return if no action is needed. 
          if not config.orchestration_stack_destroy or not File.exist?(created_stacks_fname)
            env[:machine].id = nil
            return @app.call(env)
          end

          # Create new fog orchestration service.
          env[:openstack_orchestration] = Fog::Orchestration.new(
            env[:fog_openstack_params])

          # Load IDs of stacks to be deleted.
          available_stacks = env[:openstack_orchestration].list_stacks.body['stacks']
          stacks_to_delete = []
          File.open(created_stacks_fname) { |file|
            file.each_line do |stack_id|
              stack = find_stack(available_stacks, stack_id.chomp!)
              next if not stack
              stacks_to_delete << stack
            end
          }

          # Delete stacks.
          if stacks_to_delete.length > 0
            env[:ui].info(I18n.t("vagrant_openstack.deleting_orchestration_stacks"))
          end

          stacks_to_delete.each do |stack|
            @logger.info("Removing orchestration stack #{stack['stack_name']} (#{stack['id']}).")
            env[:openstack_orchestration].delete_stack(
              stack['stack_name'], stack['id'])

            stacks_from_file.delete(stack)
          end

          # Delete file holding created stack IDs.
          @logger.info("Deleting file #{created_stacks_fname}.")
          File.delete(created_stacks_fname)

          env[:machine].id = nil
          @app.call(env)
        end

        private

        def find_stack(available_stacks, stack_id)
          available_stacks.each do |stack|
            if stack['id'] == stack_id
              return stack
            end
          end
          false
        end
      end
    end
  end
end
