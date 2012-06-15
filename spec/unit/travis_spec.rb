require 'spec_helper'
include Stoplight::Providers

describe Travis do
  use_vcr_cassette 'travis', :record => :new_episodes

  it 'should inherit from Stoplight::Provider' do
    Travis.superclass.should == Provider
  end

  context 'provider' do
    it 'should return the correct provider name' do
      provider = Travis.new('url' => 'http://travis-ci.org')
      provider.provider.should == 'travis'
    end
  end

  context 'projects' do
    context 'with no :owner_name query' do
      before do
        @provider = Travis.new('url' => 'http://travis-ci.org')
      end

      it 'should return an array of Stoplight::Project' do
        @provider.projects.class.should == Array
        @provider.projects.first.class.should == Stoplight::Project
      end

      it 'should have the correct default project attributes' do
        project = @provider.projects.first

        project.name.should == 'salt'
        project.build_url.should == 'http://travis-ci.org/saltstack/salt'
        project.last_build_id.should == '323'
        project.last_build_time.should == nil
      end

      it 'should have the correct :last_build_statuses' do
        projects = @provider.projects

        projects[0].last_build_status.should == 'unknown'
        projects[0].current_status.should == 'building'

        projects[3].last_build_status.should == 'passed'
        projects[3].current_status.should == 'done'

        projects[5].last_build_status.should == 'failed'
        projects[2].current_status.should == 'building'
      end
    end

    context 'culprits' do

    end
  end
end
