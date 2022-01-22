
# distributed algorithms, n.dulay, 10 jan 22
# basic flooding, v1

# flood message through 1-hop (fully connected) network

defmodule Flooding do

def start do
  config = Helper.node_init()
  start(config, config.start_function)
end # start/0

defp start(_,      :cluster_wait), do: :skip
defp start(config, :cluster_start) do
  IO.puts "-> Flooding at #{Helper.node_string()}"
  # add your code here
  peers = for _ <- 1..config.n_peers do
    Node.spawn(:'flooding_#{config.node_suffix}', Peer, :start, [])
  end

  create_binding(peers, 0, [1, 6])
  create_binding(peers,1,[0,2,3])
  create_binding(peers,2,[1,3,4])
  create_binding(peers,3,[1,2,5])
  create_binding(peers,4,[2])
  create_binding(peers,5,[3])
  create_binding(peers,6,[0,7])
  create_binding(peers,7,[6,8,9])
  create_binding(peers, 8, [7, 9])
  create_binding(peers, 9, [7, 8])

  send Enum.at(peers, 0), {:hello, "Hello world!", 0, self()}

end # start/2

defp create_binding(peers, origin, bindings) do
  send Enum.at(peers, origin), {:bind_to, for b <- bindings do Enum.at(peers, b) end}
end

end # Flooding
