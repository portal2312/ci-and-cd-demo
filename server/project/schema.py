"""Root schema."""

import strawberry
from blog.schema import Query as BlogQuery
from strawberry_django.optimizer import DjangoOptimizerExtension


@strawberry.type
class Query(BlogQuery):
    """Root query."""


schema = strawberry.Schema(
    query=Query,
    extensions=[
        DjangoOptimizerExtension,
    ],
)
