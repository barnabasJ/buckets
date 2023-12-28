import { createApi } from "@reduxjs/toolkit/query/react";
import { graphqlRequestBaseQuery } from "@rtk-query/graphql-request-base-query";
import { GraphQLClient } from "graphql-request";

export const client = new GraphQLClient("http://localhost:4000/gql");
// Define a service using a base URL and expected endpoints
export const api = createApi({
  reducerPath: "api",
  baseQuery: graphqlRequestBaseQuery({
    // @ts-expect-error
    client,
  }),
  endpoints: () => ({}),
});
