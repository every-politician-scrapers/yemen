#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      noko.xpath("//table[.//th[contains(.,'Incumbent')]]//tr[td]")
    end
  end

  class Member
    field :id do
      name_node.css('a/@wikidata').first
    end

    field :name do
      name_node.at_css('a') ? name_node.at_css('a').text.tidy : name_node.text.tidy
    end

    field :positionID do
    end

    field :position do
      tds[0].text.tidy
    end

    field :startDate do
      WikipediaDate.new(raw_start).to_s
    end

    field :endDate do
      WikipediaDate.new(raw_end).to_s
    end

    field :cabinet do
      'Q27943161'
    end

    private

    def tds
      noko.css('th,td')
    end

    def name_node
      tds[1]
    end

    def raw_start
      tds[2].text.tidy
    end

    def raw_end
      tds[3].text.tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
