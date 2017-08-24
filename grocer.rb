require "pry"

def consolidate_cart(cart)
  counted_cart = {}
  cart.each do |item_hash|
    item_hash.each do |item, item_specs|
      if counted_cart.include?(item)
        counted_cart[item][:count] += 1
      else
        counted_cart[item] = {
          :price => item_specs[:price],
          :clearance => item_specs[:clearance],
          :count => 1
        }
      end
    end
  end
  counted_cart
end

def apply_coupons(cart, coupons)
  coupon_cart = {}
  cart.each do |item, item_hash|
    coupon_cart[item] = item_hash
    coupons.each do |coupon_details|
      coupon_item = "#{item} W/COUPON"
      if item == coupon_details[:item]
        if item_hash[:count] >= coupon_details[:num]
          item_hash[:count] -= coupon_details[:num]
          if coupon_cart.include?(coupon_item)
            coupon_cart[coupon_item][:count] += 1
          else
            coupon_cart[coupon_item]= {
              :price => coupon_details[:cost],
              :clearance => item_hash[:clearance],
              :count => 1
            }
          end
        end
      end
    end
  end
  coupon_cart
end

def apply_clearance(cart)
  cart.each do |item, item_hash|
      if item_hash[:clearance] == true
        item_hash[:price] = (item_hash[:price]*0.8).round(2)
      end
  end
  cart
end

def checkout(cart, coupons)
  total = 0.00
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each do |item, item_hash|
    if item_hash[:count] != 0
      total += item_hash[:price] * item_hash[:count]
    end
  end
  if total > 100.00
    total = (total * 0.9).round(2)
  else
    total
  end
end
