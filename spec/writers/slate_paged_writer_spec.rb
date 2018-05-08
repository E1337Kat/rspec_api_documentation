# -*- coding: utf-8 -*-
require 'spec_helper'

describe RspecApiDocumentation::Writers::SlatePagedWriter do
  let(:index) { RspecApiDocumentation::Index.new }
  let(:configuration) { RspecApiDocumentation::Configuration.new }

  describe ".write" do
    let(:writer) { double(:writer) }

    it "should build a new writer and write the docs" do
      allow(described_class).to receive(:new).with(index, configuration).and_return(writer)
      expect(writer).to receive(:write)
      described_class.write(index, configuration)
    end
  end

  describe "#write" do
    let(:writer) { described_class.new(index, configuration) }

    it "should write the index" do
      FakeFS do
        template_dir = File.join(configuration.template_path, "rspec_api_documentation")
        FileUtils.mkdir_p(template_dir)
        index_head_template = File.open(File.join(template_dir, "slate_paged_index_head.mustache"), "w+") { |f| f << "{{ mustache }}" }
        head_template = File.open(File.join(template_dir, "slate_paged_head.mustache"), "w+") { |f| f << "{{ mustache }}" }
        index_template = File.open(File.join(template_dir, "slate_paged_index.mustache"), "w+") { |f| f << "{{ mustache }}" }
        FileUtils.mkdir_p(configuration.docs_dir)

        writer.write
        index_file = File.join(configuration.docs_dir, "index.html.md")
        expect(File.exists?(index_file)).to be_truthy
      end
    end
  end

  describe "#write_example" do
    let(:writer) { described_class.new(index, configuration) }

    it "should write the examples" do
      FakeFS do
        template_dir = File.join(configuration.template_path, "rspec_api_documentation")
        FileUtils.mkdir_p(template_dir)
        File.open(File.join(template_dir, "slate_paged_example.mustache"), "w+") { |f| f << "{{ mustache }}" }
        FileUtils.mkdir_p(configuration.docs_dir)

        writer.write
        index_file = File.join(configuration.docs_dir, "index.html.md")
        expect(File.exists?(index_file)).to be_truthy
      end
    end
  end

  context 'instance methods' do
    let(:writer) { described_class.new(index, configuration) }

    describe '#markup_index_class' do
      subject { writer.markup_index_class }
      it { is_expected.to be == RspecApiDocumentation::Views::SlatePagedIndex }
    end

    describe '#markup_example_class' do
      subject { writer.markup_example_class }
      it { is_expected.to be == RspecApiDocumentation::Views::SlatePagedExample }
    end
  end
end
