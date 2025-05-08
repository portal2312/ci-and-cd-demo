"""Blog app schema."""

import strawberry
import strawberry_django
from strawberry_django.optimizer import DjangoOptimizerExtension

from .types import Post


@strawberry.type
class Query:
    """Blog app query."""

    posts: list[Post] = strawberry_django.field()


schema = strawberry.Schema(
    query=Query,
    extensions=[
        DjangoOptimizerExtension,
    ],
)
