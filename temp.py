from PIL import Image
import os
os.chdir("imgs")
# Target dimensions
TARGET_WIDTH = 390
TARGET_HEIGHT = 975
IMAGE_EXTENSIONS = ('.jpg', '.jpeg', '.png', '.bmp', '.gif', '.tiff')

def resize_images_in_directory():
    for filename in os.listdir('.'):
        if filename.lower().endswith(IMAGE_EXTENSIONS):
            try:
                with Image.open(filename) as img:
                    resized_img = img.resize((TARGET_WIDTH, TARGET_HEIGHT), Image.LANCZOS)
                    
                    # Overwrite the original file or change filename to save elsewhere
                    resized_img.save(filename)

                    print(f"{filename}: resized to {TARGET_WIDTH}x{TARGET_HEIGHT}")
            except Exception as e:
                print(f"Error processing {filename}: {e}")

if __name__ == "__main__":
    resize_images_in_directory()
