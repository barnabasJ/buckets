import type { JsonValue } from "type-fest";

declare global {
  declare type Json = JsonValue;
}
