spreadsheet = Rails.root.join('data/biden_agency_review_teams.csv')
outdir = Rails.root.join('data/biden_agency_review')
members_employment_filepath = outdir.join("members_employment.csv")
FileUtils.mkdir_p outdir
rows = CSV.read(spreadsheet, headers: true)
members_employment_csv = CSV.open(members_employment_filepath, 'w', headers: %w[name employment], write_headers: true)

def open_team_csv(team_name)
  filepath = Rails.root.join('data/biden_agency_review', "#{team_name.tr(' ', '_')}.csv")
  CSV.open(filepath, 'w', headers: %w[name primary_ext blurb], write_headers: true) { |csv| yield csv }
end

def employment_from(member)
  if member['most_recent_employment'].blank? || member['most_recent_employment'] == 'Self-employed'
    nil
  else
    member['most_recent_employment']
  end
end

rows.group_by { |r| r['team'] }.each_pair do |team_name, members|
  open_team_csv(team_name) do |csv|

    members.each do |member|
      csv << [member['name'], 'Person', employment_from(member)]
      if employment_from(member)
        members_employment_csv << [member['name'], employment_from(member)]
      end
    end
  end
end

members_employment_csv.close
