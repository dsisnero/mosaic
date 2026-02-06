require "./spec_helper"
require "stumpy_png"
require "digest/sha256"

describe Mosaic::Renderer do
  it "renders charm-wish.png correctly with default settings" do
    # Load test image
    canvas = StumpyPNG.read("temp/charm-wish.png")
    # Create renderer with same settings as Go test
    renderer = Mosaic::Renderer.new.width(80).height(40)

    # Render image
    result = renderer.render(canvas)

    # Compare with expected SHA256 hash (avoids large string diff in output)
    expected_hash = "a061efbc97df0425994d0f1657ed7819929fff59b04a2acb98a2b271c33c7b83"
    actual_hash = Digest::SHA256.hexdigest(result)

    if actual_hash != expected_hash
      # Write actual output to temp file for debugging
      debug_path = "temp/actual_output.txt"
      File.write(debug_path, result)
      fail "Rendered output hash mismatch\nExpected SHA256: #{expected_hash}\nActual SHA256:   #{actual_hash}\nFull output written to #{debug_path} for inspection"
    end
  end

  pending "implements proper dithering" do
  end

  pending "supports color inversion" do
  end

  pending "supports different symbol sets" do
  end
end
