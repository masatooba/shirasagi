require 'spec_helper'

describe Cms::AllContent, type: :model, dbscope: :example do
  describe ".csv" do
    let(:site) { cms_site }
    let(:csv) { described_class.enum_csv(site) }

    describe "header line" do
      let(:header) { csv.to_a[0].encode('UTF-8').split(",")  }
      it { expect(header[0]).to eq(I18n.t("all_content.page_id")) }
      it { expect(header[1]).to eq(I18n.t("all_content.node_id")) }
      it { expect(header[15]).to eq(I18n.t("all_content.updated")) }
    end

    describe "contents" do
      before do
        @page = create :cms_page
        @node = create :cms_node
      end

      let(:line1) { csv.to_a[1].encode('UTF-8').split(",") }
      let(:line2) { csv.to_a[2].encode('UTF-8').split(",") }

      it { expect(line1[5]).to eq @page.full_url }
      it { expect(line2[5]).to eq @node.full_url }
    end
  end
end
