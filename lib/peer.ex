
# distributed algorithms, n.dulay, 10 jan 22
# basic flooding, v1

defmodule Peer do

  # add your code here, start(), next() and any other functions
  def start do
    IO.puts "-> Peer at #{Helper.node_string()}"
    next([], 0, MapSet.new, 0, 0)
  end

  defp next(peers, h_m, seen_ids, parent, children_count) do
    self_id = self()
    receive do
      {:bind_to, peer} -> next(peer ++ peers, h_m, seen_ids, parent, children_count)
      {:children, child_id} -> send child_id, {:children_count, Enum.count(peers)}
      {:children_count, count} -> next(peers, h_m, seen_ids, parent, count)
      {:hello, message, uid, sender_id} ->
        if !MapSet.member?(seen_ids, uid) do
          for peer <- peers do
            own_uid = self_id
            send peer, {:hello, message, uid, own_uid}
          end
        end
        send sender_id, {:children, self_id}
        next(peers, h_m + 1, MapSet.put(seen_ids, uid), sender_id, children_count)
      _ -> next(peers, h_m, seen_ids, parent, children_count)
    after # recieve
      1_000 -> IO.puts "Peer #{inspect(self_id)} Parent #{inspect parent} Child count=#{children_count}"
    end # after
    next(peers, h_m, seen_ids, parent, children_count)
  end
end # Peer
