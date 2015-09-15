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
    binding.pry
    inactive_lcs.each do |lc|
      lc.delete
    end
  end

  def active_lcs
    lcs_associated_with_asg_instances + lcs_associated_with_asgs
  end

  def lcs_associated_with_asg_instances

  end

  def lcs_associated_with_asgs

  end

  def inactive_lcs
    all_lcs - active_lcs
  end

  def all_lcs
    
  end
end

DeathToLcs.run