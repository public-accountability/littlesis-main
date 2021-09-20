#!/usr/bin/env -S rails runner

require 'importers/congress_importer'

File.write Rails.root.join('data/opensecrets_fec_map.json'),
           JSON.pretty_generate(
             CongressImporter.new.reps.each_with_object({}) do |legislator, h|
               if legislator.dig('id', 'opensecrets') && legislator.dig('id', 'fec')
                 h.store legislator.dig('id', 'opensecrets'), legislator.dig('id', 'fec')
               end
             end
           )
