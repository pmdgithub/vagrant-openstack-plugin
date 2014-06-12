require "fog"
require "log4r"

module VagrantPlugins
  module OpenStack
    module Action
      class CreateOrchestrationStack

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new(
            "vagrant_openstack::action::create_orchestration_stack")
        end

        def call(env)
          # Get the config.
          config = env[:machine].provider_config

          # Are we going to handle orchestration stacks?
          if not config.orchestration_stack_name
            return @app.call(env)
          end

          # Create new fog orchestration service.
          env[:openstack_orchestration] = Fog::Orchestration.new(
            env[:fog_openstack_params])

          # Check if stack is already created.
          env[:openstack_orchestration].list_stacks.body['stacks'].each do |stack|
            if config.orchestration_stack_name == stack['stack_name']
              return @app.call(env)
            end
          end

          # To avoid confusion, only one source for orchestration template
          # should be set.
          if [config.orchestration_cfn_template,
              config.orchestration_cfn_template_file,
              config.orchestration_cfn_template_url].count(nil) != 2
            raise Errors::OrchestrationTemplateError,
              :err => 'One source for orchestration template should be specified.'
          end

          # Prepare parameters for new orchestration stack.
          # TODO: configurable parameters
          stack_params = {
            :disable_rollback   => false,
            :timeout_in_minutes => 5,
          }

          # Set template source.
          if config.orchestration_cfn_template
            stack_params[:template] = config.orchestration_cfn_template
          elsif config.orchestration_cfn_template_file
            if not File.exist?(config.orchestration_cfn_template_file)
              raise Errors::OrchestrationNoTemplateFileError,
                :fname => config.orchestration_cfn_template_file
            end

            # Load template file content. Newlines can cause parse error of
            # input JSON string.
            stack_params[:template] = ''
            File.open(config.orchestration_cfn_template_file) { |file|
              file.each_line do |line|
                stack_params[:template] << line
              end
            }
          else
            stack_params[:template_url] = config.orchestration_cfn_template_url
          end

          # Set template parameters.
          stack_params[:parameters] = config.orchestration_cfn_template_parameters

          # Create new stack.
          env[:ui].info(I18n.t("vagrant_openstack.creating_orchestration_stack"))
          stack = env[:openstack_orchestration].create_stack(
            config.orchestration_stack_name, stack_params)

          # Write UUID of newly created stack into file for later use (stack removal).
          created_stacks_fname = env[:machine].data_dir + 'orchestration_stacks'
          message = 'Saving information about created orchestration stack '
          message << "#{config.orchestration_stack_name}, "
          message << "UUID=#{stack.body['stack']['id']} "
          message << "to file #{created_stacks_fname}."
          @logger.info(message)

          File.open(created_stacks_fname, 'a') do |file|
            file.puts stack.body['stack']['id']
          end

          @app.call(env)
        end
      end
    end
  end
end
