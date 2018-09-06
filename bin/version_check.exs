try do
    # if no args submitted and exception is raised
    if hd(System.argv()) =~ ~r{^(\d+\.)(\d+\.)(\d+)$} do
    System.stop(0)
    else
    System.stop(1)
    end
rescue
    # if exception it's a invalid version
    _ -> System.stop(1)
end

# Believe the receive block prevents the race condition so 
# that halt will work correctly
receive do
  {:hello, msg} -> msg
after
  10_000 -> "nothing after 1s"
end