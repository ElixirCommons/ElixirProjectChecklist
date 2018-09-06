# https://github.com/PragTob/benchee


map_fun = fn(i) -> i + 1 end
inputs = %{
  "Small (1 Thousand)"    => Enum.to_list(1..1_000),
  "Middle (100 Thousand)" => Enum.to_list(1..100_000),
  "Big (10 Million)"      => Enum.to_list(1..10_000_000),
}

Benchee.run %{
    "flat_map"    => fn(_) -> 1+1 end,
    "map.flatten" => fn(list) -> list |> IO.inspect |> Enum.map(map_fun) |> List.flatten end
}, time: 15, warmup: 5, inputs: inputs, formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ],
  formatter_options: [html: [file: "_benchmarks/sample.html"]]