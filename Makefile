post:
	@read -p "entry_name: " SLUG; ./scripts/new $${SLUG}
preview:
	./scripts/preview
deploy:
	./scripts/deploy
resize-image:
	@read -p "image path: " IMAGE; ./scripts/resize-image $${IMAGE}
copy-blog-to-spinners:
	@read -p "entry_name: " SLUG; ./scripts/copy-blog-to-spinners $${SLUG}
