import { gql } from "graphql-request";

export const postsQueryDocument = gql`
  query Posts {
    posts {
      title
      content
      createdAt
    }
  }
`;

const Posts = () => {};

export default Posts;
