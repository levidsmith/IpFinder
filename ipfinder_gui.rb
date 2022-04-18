#2022 Levi D. Smith - levidsmith.com
require 'gtk3'
require_relative 'ipfinder'

def makeWindow()
    window = Gtk::Window.new("IpFinder")
    window.set_size_request(640, 480)
    window.set_border_width(10)

    grid = Gtk::Grid.new

    #URL bar
    $entryUrlInput = Gtk::Entry.new
    grid.attach($entryUrlInput, 0, 0, 1, 1)

    #Go button
    $buttonGo = Gtk::Button.new(:label => "Go")
    $buttonGo.signal_connect "clicked" do  |_widget| 
#        $ipfinder.find("https://bing.com") 
        $ipfinder.find($entryUrlInput.text)
        showPage($entryUrlInput.text)
    end
    grid.attach($buttonGo, 0, 1, 1, 1)

    #page display
    $entryContent = Gtk::TextView.new
#    $entryContent.text = "Hello\none\ntwo\nthree"
    $contentBuffer = Gtk::TextBuffer.new
    $entryContent.set_buffer($contentBuffer)
    scrolledWindow = Gtk::ScrolledWindow.new()
    scrolledWindow.min_content_width = 1200
    scrolledWindow.min_content_height = 400
    scrolledWindow.vscrollbar_policy = Gtk::PolicyType::ALWAYS

    scrolledWindow.add($entryContent)
    grid.attach(scrolledWindow, 0, 2, 1, 1)



    #links
    scrolledWindow = Gtk::ScrolledWindow.new()
    scrolledWindow.min_content_width = 1200
    scrolledWindow.min_content_height = 400
    scrolledWindow.vscrollbar_policy = Gtk::PolicyType::ALWAYS

    $tableDomains = Gtk::Table.new(1,1, false)
    label1 = Gtk::Label.new("levidsmith.com")
    $tableDomains.attach(label1, 0, 1, 0, 1, Gtk::AttachOptions::SHRINK, Gtk::AttachOptions::SHRINK, 0, 1)
    label1.show

    label2 = Gtk::Label.new("gamejolt.com")
    $tableDomains.attach(label2, 0, 1, 1, 2, Gtk::AttachOptions::SHRINK, Gtk::AttachOptions::SHRINK, 0, 1)
    label2.show

    $tableDomains.set_row_spacing(0, 8)



    scrolledWindow.add($tableDomains)

    grid.attach(scrolledWindow, 0, 3, 1, 1)

    buttonShowDomains = Gtk::Button.new(:label => "Show Domains")
    buttonShowDomains.signal_connect "clicked" do  |_widget| 
        showDomains()
        #$ipfinder.printAllDomains()
    end
    grid.attach(buttonShowDomains, 0, 4, 1, 1)



    window.add(grid)
    window.signal_connect("delete-event") { |_widget| Gtk.main_quit }
    window.show_all


end

def showPage(strURL) 
#    $contentBuffer.set_text(#{$ipfinder.getContent(strURL)})
    strContent = $ipfinder.getContent(strURL)
    strContent = strContent.force_encoding('utf-8')
    puts strContent
    $contentBuffer.set_text(strContent)


end

def showDomains()
#    $ipfinder.printAllDomains()


    $tableDomains.children.each do | child |
        $tableDomains.remove(child)
    end

    iRow = 0
    $ipfinder.getAllDomains().each do | domain |

        label1 = Gtk::Label.new(domain)
        $tableDomains.attach(label1, 0, 1, iRow, iRow + 1, Gtk::AttachOptions::SHRINK, Gtk::AttachOptions::SHRINK, 0, 1)
        label1.expand = true
        #label1.set_alignment(0, 0.5)
        #label1.justify = Gtk::JUSTIFY_LEFT
        label1.override_background_color(:normal, Gdk::RGBA::new(0.9, 0.9, 1.0, 1.0))
        label1.show
        iRow += 1
    end


end

$ipfinder = IpFinder.new

makeWindow()
Gtk.main