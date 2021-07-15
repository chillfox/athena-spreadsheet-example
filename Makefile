.PHONY: all run webpack dependencies clean

all: webpack run

run:
	@echo "Running Crystal..."
	@crystal run src/server.cr

webpack:
	@echo "Running Webpack..."
	@npm run build

dependencies:
	@echo "Downloading dependencies..."
	@shards install
	@npm install

clean:
	@echo "Cleaning..."
	@rm -r dist

