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
    expected_hash = "b3b74eb49ddef0d65defc8be4c6c589b42d49885970ee74067e6d9faf6cb7e1d"
    actual_hash = Digest::SHA256.hexdigest(result)
    expected_len = 25648
    actual_len = result.bytesize

    if actual_hash != expected_hash || actual_len != expected_len
      # Write actual output to temp file for debugging
      debug_path = "temp/actual_output.txt"
      File.write(debug_path, result)
      fail "Rendered output mismatch\nExpected SHA256: #{expected_hash}\nActual SHA256:   #{actual_hash}\nExpected length: #{expected_len}\nActual length:   #{actual_len}\nFull output written to #{debug_path} for inspection"
    end
  end

  it "implements proper dithering" do
    canvas = StumpyPNG.read("temp/charm-wish.png")
    renderer_no_dither = Mosaic::Renderer.new.width(80).height(40).dither(false)
    renderer_dither = Mosaic::Renderer.new.width(80).height(40).dither(true)

    result_no_dither = renderer_no_dither.render(canvas)
    result_dither = renderer_dither.render(canvas)

    # Dithering should produce different output for this image
    result_dither.should_not eq(result_no_dither)
  end

  it "supports color inversion" do
    canvas = StumpyPNG.read("temp/charm-wish.png")
    renderer_no_invert = Mosaic::Renderer.new.width(80).height(40).invert_colors(false)
    renderer_invert = Mosaic::Renderer.new.width(80).height(40).invert_colors(true)

    result_no_invert = renderer_no_invert.render(canvas)
    result_invert = renderer_invert.render(canvas)

    # Color inversion should produce different output for this image
    result_invert.should_not eq(result_no_invert)
  end

  it "supports different symbol sets" do
    canvas = StumpyPNG.read("temp/charm-wish.png")

    # Test each symbol type
    renderer_half = Mosaic::Renderer.new.width(80).height(40).symbol(Mosaic::Symbol::Half)
    renderer_quarter = Mosaic::Renderer.new.width(80).height(40).symbol(Mosaic::Symbol::Quarter)
    renderer_all = Mosaic::Renderer.new.width(80).height(40).symbol(Mosaic::Symbol::All)

    result_half = renderer_half.render(canvas)
    result_quarter = renderer_quarter.render(canvas)
    result_all = renderer_all.render(canvas)

    # Results should not be empty
    result_half.should_not be_empty
    result_quarter.should_not be_empty
    result_all.should_not be_empty

    # At least two symbol sets should produce different output
    # (not guaranteed but likely for our test image)
    (result_half == result_quarter && result_half == result_all).should be_false
  end
end
