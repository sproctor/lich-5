# Lich5 carveout - manual login screen for GUI

# GUI Update page
# This page is intended to be provide a Lich update status

require 'json'
require 'open-uri'

@lich_update_to = ''
@lich_update_scripts = ''
@lich_update_lib = ''
@lich_recommended_scripts = ''
@lich_new_features = ''

get_update_status = proc { |type|
  installed = Gem::Version.new(@current)
  filename = "https://raw.githubusercontent.com/elanthia-online/lich-5/master/data/update-lich5.json"
  update_info = open(filename).read
  JSON::parse(update_info).each { |entry|
    if entry["update_type"]["#{type}"] && (Gem::Version.new(entry["version_lich"]) > installed || type = :refresh)
      @lich_update_to = entry["version_lich"]
      @lich_update_scripts = entry["update_core_scripts"] if !entry["update_core_scripts"].empty?
      @lich_update_lib = entry["update_libs"] if !entry["update_libs"].empty?
      convert_hash = JSON[entry["recommend_update_scripts"]] if !entry["recommend_update_scripts"].empty?
      if convert_hash
      @lich_recommend_scripts = JSON[convert_hash]
      else
        @lich_recommend_scripts = []
      end
      @new_features = entry["announce_features"] if !entry["announce_features"].empty?
    else
      next
    end
   }
}

prep_update.call(:current)

version_table = Gtk::Table.new(5, 2, false)
version_table.attach(Gtk::Label.new('Lich Version:'), 0, 1, 0, 1, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
version_table.attach(Gtk::Label.new("#{LICH_VERSION}"), 1, 2, 0, 1, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
version_table.attach(Gtk::Label.new('Ruby Version:'), 0, 1, 1, 2, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
version_table.attach(Gtk::Label.new("#{RUBY_VERSION}"), 1, 2, 1, 2, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
version_table.attach(Gtk::Label.new('Ruby Platform:'), 0, 1, 2, 3, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
version_table.attach(Gtk::Label.new("#{RUBY_PLATFORM}"), 1, 2, 2, 3, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
version_table.attach(Gtk::Label.new('Ruby Engine:'), 0, 1, 3, 4, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
version_table.attach(Gtk::Label.new("#{RUBY_ENGINE}"), 1, 2, 3, 4, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
version_table.attach(Gtk::Label.new('GTK Version:'), 0, 1, 4, 5, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
version_table.attach(Gtk::Label.new("TBD"), 1, 2, 4, 5, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)


up_to_date_table = Gtk::Table.new(1, 1, false)
up_to_date_table.attach(Gtk::Label.new("Lich is up to date, Hurray!"), 0, 1, 0, 1, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)

#@lich_update_to = ''
#@lich_update_scripts = ''
#@lich_update_lib = ''
#@lich_recommended_scripts = ''
#@lich_new_features = ''

update_table = Gtk::Table.new(5, 2, false)
update_table.attach(Gtk::Label.new("New Lich Version Available"), 0, 1, 0, 1, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
update_table.attach(Gtk::Label.new("#{@lich_update_to}"), 1, 2, 0, 1, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
update_table.attach(Gtk::Label.new('New Libraries Available:'), 0, 1, 1, 2, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
update_table.attach(@lich_update_lib.each { |lib| Gtk::Label.new(lib) }, 1, 2, 1, 2, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
update_table.attach(Gtk::Label.new('New Scripts Available:'), 0, 1, 2, 3, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
update_table.attach(@lich_update_scripts.each { |script| Gtk::Label.new(script)}, 1, 2, 2, 3, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
update_table.attach(Gtk::Label.new('Recommended Scripts:'), 0, 1, 3, 4, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
update_table.attach(@lich_recommended_scripts.each { |script| Gtk::Label.new(script), 1, 2, 3, 4, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
update_table.attach(Gtk::Label.new('New Features:'), 0, 1, 4, 5, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)
update_table.attach(@lich_new_features.each { |feature| Gtk::Label.new(feature), 1, 2, 4, 5, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, Gtk::AttachOptions::EXPAND | Gtk::AttachOptions::FILL, 5, 5)

@gui_update_page_tab = Gtk::Box.new(:vertical)
@gui_update_page_tab.border_width = 5
@gui_update_page_tab.pack_start(version_table, :expand => false, :fill => false, :padding => 0)
if "#{LICH_VERSION}".chr == '5'
  if Gem::Version.new(@current) < Gem::Version.new(@update_to)
    @gui_update_page_tab.pack_start(update_table, :expand => false, :fill => false, :padding => 0)
  else
    @gui_update_page_tab.pack_start(up_to_date_table, :expand => false, :fill => false, :padding => 0)
  end
end
