require 'test/unit/assertions'
require_relative './sub-array'

module MergeSortContract
  include Test::Unit::Assertions
  # Module, so no class invariant
  
  def pre_sortInPlace(arr, duration)
    assert arr.is_a?(Array), "arr must be of type Array"
    assert duration.kind_of?(Numeric), "duration must be numeric"
    @len = arr.length
  end
  
  def post_sortInPlace(arr, duration)
    assert arr.is_a?(Array)
    assert_equal @len, arr.length
  end
  
  def pre_mergesort(arr, lefti, righti)
    assert arr.is_a?(Array), "arr must be of type Array"
    assert lefti.between?(0,arr.length-1), "left index must be within bounds"
    assert righti.between?(0,arr.length-1), "right index must be within bounds"

  end
  
  def post_mergesort(arr, lefti, righti)
    assert arr.is_a?(Array), "arr must be of type Array"
  end
  
  def pre_merge(arr, subArr1, subArr2)
    assert arr.class == Array || arr.class == SubArray, "arr must be of type Array or SubArray"
    assert subArr1.class == SubArray, "subArr1 must be of type SubArray"
    assert subArr2.class == SubArray, "subArr2 must be of type SubArray"

  end
  
  def post_merge(arr, subArr1, subArr2)
    assert arr.class == Array || arr.class == SubArray, "arr must be of type Array or SubArray"
  end
  
  
  def pre_binarySearch(arr, elem)
    assert arr.class ==  Array || arr.class == SubArray, "arr must be of type Array or SubArray"
  end
  
  def post_binarySearch(arr, elem)
  end

end