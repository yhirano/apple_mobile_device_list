require 'rexml/document'
require 'open-uri'

URL = 'http://mesu.apple.com/assets/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml'

DeviceInfo = Struct.new(:hw, :url)
device_info_map = {}

doc = nil

open(URL) { |file|
  doc = REXML::Document.new file
}

doc.elements.each('/plist/dict/array/dict') { |elem|
  is_next_devices = false
  elem.each_element { |elem|
    if elem.name == 'key' && elem.text == 'SupportedDevices'
      is_next_devices = true
    else
      if is_next_devices
        elem.each_element { |elem|
          if elem != nil && elem.name == 'string'
            device_name = elem.text
            url = "http://www.apple.com/legal/rfexposure/#{device_name}/cs/"
            device_info_map[device_name] = DeviceInfo.new(device_name, url)
          end
        }
      end
      is_next_devices = false
    end
  }
}

device_info_map.sort.each { |k,v|
  puts v.hw + "\t" + v.url
}