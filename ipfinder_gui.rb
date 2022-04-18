require 'gtk3'
require_relative 'ipfinder'

def makeWindow()
    window = Gtk::Window.new("IpFinder")
    window.set_size_request(640, 480)
    window.set_border_width(10)

    grid = Gtk::Grid.new

    $entryUrlInput = Gtk::Entry.new
    grid.attach($entryUrlInput, 0, 0, 1, 1)

    $buttonGo = Gtk::Button.new(:label => "Go")
    $buttonGo.signal_connect "clicked" do  |_widget| 
#        $ipfinder.find("https://bing.com") 
        $ipfinder.find($entryUrlInput.text) 
    end
    grid.attach($buttonGo, 0, 1, 1, 1)


    scrolledWindow = Gtk::ScrolledWindow.new()
    scrolledWindow.min_content_width = 1200
    scrolledWindow.min_content_height = 400
    scrolledWindow.vscrollbar_policy = Gtk::PolicyType::ALWAYS

#    labelLinkedDomains = Gtk::Label.new
#    labelLinkedDomains.label = "Linked domains"
#    scrolledWindow.add(labelLinkedDomains)
    $tableDomains = Gtk::Table.new(1,1, false)
    label1 = Gtk::Label.new("levidsmith.com")
    $tableDomains.attach(label1, 0, 1, 0, 1, Gtk::AttachOptions::SHRINK, Gtk::AttachOptions::SHRINK, 0, 1)
    label1.show

    label2 = Gtk::Label.new("gamejolt.com")
    $tableDomains.attach(label2, 0, 1, 1, 2, Gtk::AttachOptions::SHRINK, Gtk::AttachOptions::SHRINK, 0, 1)
    label2.show

    $tableDomains.set_row_spacing(0, 8)



    scrolledWindow.add($tableDomains)

    grid.attach(scrolledWindow, 0, 2, 1, 1)

    buttonShowDomains = Gtk::Button.new(:label => "Show Domains")
    buttonShowDomains.signal_connect "clicked" do  |_widget| 
        showDomains()
        #$ipfinder.printAllDomains()
    end
    grid.attach(buttonShowDomains, 0, 3, 1, 1)



    window.add(grid)
    window.signal_connect("delete-event") { |_widget| Gtk.main_quit }
    window.show_all


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