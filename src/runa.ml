let ( <!> ) obj field = Js.Unsafe.get obj field

let ( !@ ) f = Js.wrap_callback f

let ( !! ) o = Js.Unsafe.inject o

let stringify o = Js._JSON##stringify o |> Js.to_string

let m = Js.Unsafe.meth_call

let merge a b : < .. > Js.t = Js.Unsafe.global##.Object##assign a b

let object_of_table t =
  let js_keys = Jstable.keys t in
  let values =
    js_keys
    |> List.map
      (fun k -> (Jstable.find t k |> Js.Optdef.get)
          (fun () -> assert false))
  in
  List.map2 (fun k v -> (Js.to_string k, v)) js_keys values
  |> Array.of_list
  |> Js.Unsafe.obj

let debug item =
  (Js.Unsafe.global##.DEBUG_VAR := item) |> ignore

let log l =
  Firebug.console##log l

let set_interval ~every:float (callback: unit -> unit) =
  Dom_html.window##setInterval !@callback float

let with_this f = !!(Js.wrap_meth_callback f)

let to_string_list g =
  g |> Js.str_array |> Js.to_array |> Array.map Js.to_string |> Array.to_list

let of_string_list g =
  g |> Array.of_list |> Array.map Js.string |> Js.array

let require s =
  Js.Unsafe.fun_call
    (Js.Unsafe.js_expr "require")
    [|Js.Unsafe.inject (Js.string s)|]

let json_parse s = Js._JSON##parse (s |> Js.string)

let keys obj =
  m (Js.Unsafe.variable "Object") "keys" [|obj|]
  |> Js.to_array |> Array.map Js.to_string |> Array.to_list

let for_each_iter ~f obj =
  keys obj |> List.iter (fun k -> f (Js.Unsafe.get obj k)
                                  |> ignore)

let for_each_map ~f obj =
  keys obj |> List.map (fun k -> f k (Js.Unsafe.get obj k))

let time_now () = (new%js Js.date_now)##getTime
