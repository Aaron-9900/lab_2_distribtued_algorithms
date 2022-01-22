
# distributed algorithms, n.dulay, 10 jan 22
# basic flooding, v1

defmodule Peer do

  # add your code here, start(), next() and any other functions
  def start do
    IO.puts "-> Peer at #{Helper.node_string()}"
    next([], 0, MapSet.new, 0)
  end

  defp next(peers, h_m, seen_ids, parent) do
    receive do
      {:bind_to, peer} -> next(peer ++ peers, h_m, seen_ids, parent)
      {:hello, message, uid, sender_id} ->
        if !MapSet.member?(seen_ids, uid) do
          for peer <- peers do
            own_uid = self()
            send peer, {:hello, message, uid, own_uid}
          end
        end
        next(peers, h_m + 1, MapSet.put(seen_ids, uid), sender_id)
      _ -> next(peers, h_m, seen_ids, parent)
    after # recieve
      1_000 -> IO.puts "Peer #{inspect(self())} Parent #{inspect parent} Messages seen=#{h_m}"
    end # after
    next(peers, h_m, seen_ids, parent)
  end
end # Peer
