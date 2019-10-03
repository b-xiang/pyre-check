(* Copyright (c) 2016-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree. *)

type mode =
  | Debug
  | Strict
  | Unsafe
  | Declare
  | Infer
[@@deriving compare, eq, show, sexp, hash]

type local_mode =
  | Default
  | Debug
  | Strict
  | Unsafe
  | Declare
  | PlaceholderStub
[@@deriving compare, eq, show, sexp, hash]

module Metadata : sig
  type t = {
    autogenerated: bool;
    local_mode: local_mode;
    unused_local_modes: local_mode list;
    ignore_codes: int list;
    ignore_lines: Ignore.t list;
    version: int;
    number_of_lines: int;
    raw_hash: int;
  }
  [@@deriving compare, eq, show, hash, sexp]

  val create_for_testing
    :  ?autogenerated:bool ->
    ?local_mode:local_mode ->
    ?unused_local_modes:local_mode list ->
    ?ignore_codes:int list ->
    ?ignore_lines:Ignore.t list ->
    ?version:int ->
    ?raw_hash:int ->
    ?number_of_lines:int ->
    unit ->
    t

  val parse : qualifier:Reference.t -> string list -> t
end

type t = {
  docstring: string option;
  metadata: Metadata.t;
  source_path: SourcePath.t;
  statements: Statement.t list;
}
[@@deriving compare, eq, hash, show, sexp]

val create_from_source_path
  :  docstring:string option ->
  metadata:Metadata.t ->
  source_path:SourcePath.t ->
  Statement.t list ->
  t

val create
  :  ?docstring:string option ->
  ?metadata:Metadata.t ->
  ?relative:string ->
  ?is_external:bool ->
  ?priority:int ->
  Statement.t list ->
  t

val mode : configuration:Configuration.Analysis.t -> local_mode:local_mode -> mode

val ignore_lines : t -> Ignore.t list

val statements : t -> Statement.t list

val top_level_define : t -> Statement.Define.t

val top_level_define_node : t -> Statement.Define.t Node.t

val wildcard_exports_of : t -> Reference.t list

val expand_relative_import : from:Reference.t -> t -> Reference.t
