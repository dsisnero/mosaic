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
    expected_hash = "5cc5702e3fd8edc8405ac75c6ff14170effaf585f862dafae0c03a9cc588bbe7"
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
