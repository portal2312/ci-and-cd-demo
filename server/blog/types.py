"""Blog app types."""

import strawberry_django
from strawberry import auto

from . import models


@strawberry_django.type(models.Post)
class Post:
    """Post type."""

    title: auto
    content: auto
    created_at: auto
