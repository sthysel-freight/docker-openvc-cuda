build:
	docker build -t opencv-cuda .

update:
	git submodule update --recursive --remote --init
