local preferred = {
  {
    ["audio.sink"] = { "node.name", "^alsa_output%.usb%-Apple__Inc%._EarPods_" },
    ["audio.source"] = { "node.name", "^alsa_input%.usb%-Apple__Inc%._EarPods_" },
  },
  {
    ["audio.sink"] = { "node.name", "^alsa_output%.usb%-Logitech_Logitech_MeetUp_" },
    ["audio.source"] = { "node.name", "^alsa_input%.usb%-Logitech_Logitech_MeetUp_" },
    ["video.source"] = { "node.description", "^Logitech MeetUp" },
  },
}

SimpleEventHook {
  name = "custom/preferred-default",
  after = "default-nodes/find-best-default-node",
  before = "default-nodes/apply-default-node",
  interests = {
    EventInterest {
      Constraint { "event.type", "=", "select-default-node" },
    },
  },
  execute = function (event)
    local node_type = event:get_properties () ["default-node.type"]
    local available_nodes = event:get_data ("available-nodes")
    if not available_nodes then
      return
    end
    available_nodes = available_nodes:parse ()

    for _, device in ipairs (preferred) do
      local match = device [node_type]
      if match then
        for _, node_props in ipairs (available_nodes) do
          local value = node_props [match [1]]
          if value and value:find (match [2]) then
            event:set_data ("selected-node", node_props ["node.name"])
            return
          end
        end
      end
    end
  end
}:register ()
