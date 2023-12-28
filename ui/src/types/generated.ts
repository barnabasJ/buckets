export type Maybe<T> = T;
export type InputMaybe<T> = T;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
};

export type Bucket = {
  __typename?: 'Bucket';
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
};

export type BucketFilterId = {
  eq?: InputMaybe<Scalars['ID']['input']>;
  greaterThan?: InputMaybe<Scalars['ID']['input']>;
  greaterThanOrEqual?: InputMaybe<Scalars['ID']['input']>;
  in?: InputMaybe<Array<Scalars['ID']['input']>>;
  isNil?: InputMaybe<Scalars['Boolean']['input']>;
  lessThan?: InputMaybe<Scalars['ID']['input']>;
  lessThanOrEqual?: InputMaybe<Scalars['ID']['input']>;
  notEq?: InputMaybe<Scalars['ID']['input']>;
};

export type BucketFilterInput = {
  and?: InputMaybe<Array<BucketFilterInput>>;
  id?: InputMaybe<BucketFilterId>;
  name?: InputMaybe<BucketFilterName>;
  not?: InputMaybe<Array<BucketFilterInput>>;
  or?: InputMaybe<Array<BucketFilterInput>>;
};

export type BucketFilterName = {
  eq?: InputMaybe<Scalars['String']['input']>;
  greaterThan?: InputMaybe<Scalars['String']['input']>;
  greaterThanOrEqual?: InputMaybe<Scalars['String']['input']>;
  in?: InputMaybe<Array<Scalars['String']['input']>>;
  isNil?: InputMaybe<Scalars['Boolean']['input']>;
  lessThan?: InputMaybe<Scalars['String']['input']>;
  lessThanOrEqual?: InputMaybe<Scalars['String']['input']>;
  notEq?: InputMaybe<Scalars['String']['input']>;
};

export enum BucketSortField {
  Id = 'ID',
  Name = 'NAME'
}

export type BucketSortInput = {
  field: BucketSortField;
  order?: InputMaybe<SortOrder>;
};

export type RootQueryType = {
  __typename?: 'RootQueryType';
  buckets: Array<Bucket>;
};


export type RootQueryTypeBucketsArgs = {
  filter?: InputMaybe<BucketFilterInput>;
  sort?: InputMaybe<Array<InputMaybe<BucketSortInput>>>;
};

export enum SortOrder {
  Asc = 'ASC',
  AscNullsFirst = 'ASC_NULLS_FIRST',
  AscNullsLast = 'ASC_NULLS_LAST',
  Desc = 'DESC',
  DescNullsFirst = 'DESC_NULLS_FIRST',
  DescNullsLast = 'DESC_NULLS_LAST'
}
