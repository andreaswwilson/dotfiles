local patterns = {
  ["audio.sink"] = "^alsa_output%.usb%-Apple__Inc%._EarPods_",
  ["audio.source"] = "^alsa_input%.usb%-Apple__Inc%._EarPods_",
}

SimpleEventHook {
  name = "custom/earpods-default",
  after = "default-nodes/find-best-default-node",
  before = "default-nodes/apply-default-node",
  interests = {
    EventInterest {
      Constraint { "event.type", "=", "select-default-node" },
    },
  },
  execute = function (event)
    local pattern = patterns [event:get_properties () ["default-node.type"]]
    local available_nodes = event:get_data ("available-nodes")
    if not pattern or not available_nodes then
      return
    end

    for _, node_props in ipairs (available_nodes:parse ()) do
      local name = node_props ["node.name"]
      if name and name:find (pattern) then
        event:set_data ("selected-node", name)
        return
      end
    end
  end
}:register ()
