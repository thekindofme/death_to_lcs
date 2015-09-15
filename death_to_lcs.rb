require 'dotenv'
require 'slop'
require 'pry'
require 'aws-sdk'

class DeathToLcs
  VERSION='0.1'

  def self.run
    load_env
    opts = parse_args
    lc_deleter.delete_unused_lcs
  end

  def self.lc_deleter
    LcDeleter.new
  end

  def self.parse_args
    Slop.parse do |o|
      o.on '--version', 'print the version' do
        puts DeathToLcs::VERSION
        exit
      end
    end
  end

  def self.load_env
    Dotenv.load
  end
end

class LcDeleter
  def delete_unused_lcs
    inactive_lcs.each do |lc|
      lc.delete
    end
  end

  def active_lc_names
    lc_names_associated_with_asg_instances + lc_names_associated_with_asgs
  end

  def lc_names_associated_with_asg_instances
    aws_wrapper.all_asg_instances.collect do |instance|
      instance.launch_configuration_name
    end
  end

  def lc_names_associated_with_asgs
    aws_wrapper.all_asgs.collect do |asg|
      asg.launch_configuration_name
    end
  end

  def inactive_lcs
    all_lcs.collect do |lc|
      lc unless active_lc_names.include?(lc.launch_configuration_name)
    end.compact
  end

  def all_lcs
    aws_wrapper.all_lcs
  end

  def aws_wrapper
    AwsWrapper.new
  end
end

class AwsWrapper
  def all_lcs
    results = []
    while true
      result = client.describe_launch_configurations
      results = results + result.launch_configurations

      if result.last_page?
        break
      else
        result.next_page
      end
    end

    results
  end

  def all_asg_instances
    results = []
    while true
      result = client.describe_auto_scaling_instances
      results = results + result.auto_scaling_instances

      if result.last_page?
        break
      else
        result.next_page
      end
    end

    results
  end

  def all_asgs
    results = []
    while true
      result = client.describe_auto_scaling_groups
      results = results + result.auto_scaling_groups

      if result.last_page?
        break
      else
        result.next_page
      end
    end

    results
  end

  private
  def client
    Aws::AutoScaling::Client.new
  end
end

DeathToLcs.run