ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

# PHONY means that it doesn't correspond to a file; it always runs the build commands.

.PHONY: build-all
build-all: build-dynamic

.PHONY: run-all
run-all: run-dynamic

.PHONY: build-dynamic
build-dynamic:
	@cd frontend/backend && cargo build --release
	@cp frontend/backend/target/release/libbackend.so frontend/backend/
	@cd frontend && go build -ldflags="-r $(ROOT_DIR)frontend/backend" main.go

.PHONY: run-dynamic
run-dynamic: build-dynamic
	@./frontend/main

# This is just for running the Rust lib tests natively via cargo
.PHONY: test-rust-lib
test-rust-lib:
	@cd backend && cargo test -- --nocapture

.PHONY: clean
clean:
	rm -rf frontend/main frontend/backend/libbackend.so frontend/backend/target