# LittleSis Tasks

## Repopulate the cache

Network Map Collections - list of maps and the entities they contain

``` sh
bundle exec rake maps:update_all_entity_map_collections
```

Cache all common names

``` sh
bundle exec rake common_names:warm_cache
```

## Database

Create a new copy of the development database. Saves file to `data/development_db_[DATE].sql`

``` sh
bundle exec rake mysql:development_db
```
