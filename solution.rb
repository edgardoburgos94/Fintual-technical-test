require 'pincers'

def fill_arr_price_and_arr_title(pincers, arr_price, arr_title)
  pincers.search('.listing-item__price').map do |div|
    arr_price.push(div.search(tag: 'p').text) # div is also a contex!
  end

  pincers.search('.listing-item__header').map do |div|
    arr_title.push(div.search(tag: 'a').search('.listing-item__title').text.split(' ')[0])
  end

  return arr_title, arr_price
end

def run_pincers

  Pincers.for_webdriver :chrome do |pincers|

    arr_price = []
    arr_title = []

    pincers.goto 'https://chileautos.cl/autos/busqueda?q=%28And.Tipo.Usado._.TipoVeh%C3%ADculo.Autos%2C%20camionetas%20y%204x4._.Regi%C3%B3n.Metropolitana%20de%20Santiago._.%28C.Marca.Toyota._.Modelo.YARIS.%29_.Ano.range%282011..2018%29._.Precio.range%284000000..12000000%29._.Carroceria.sed%C3%A1n.%29'
    arr_title, arr_price = fill_arr_price_and_arr_title(pincers, arr_price, arr_title)

    pincers.goto 'https://chileautos.cl/autos/busqueda?s=20&q=%28And.Tipo.Usado._.TipoVeh%C3%ADculo.Autos%2C%20camionetas%20y%204x4._.Regi%C3%B3n.Metropolitana%20de%20Santiago._.%28C.Marca.Toyota._.Modelo.YARIS.%29_.Ano.range%282011..2018%29._.Precio.range%284000000..12000000%29._.Carroceria.sed%C3%A1n.%29'
    arr_title, arr_price = fill_arr_price_and_arr_title(pincers, arr_price, arr_title)

    pincers.goto 'https://chileautos.cl/autos/busqueda?s=40&q=%28And.Tipo.Usado._.TipoVeh%C3%ADculo.Autos%2C%20camionetas%20y%204x4._.Regi%C3%B3n.Metropolitana%20de%20Santiago._.%28C.Marca.Toyota._.Modelo.YARIS.%29_.Ano.range%282011..2018%29._.Precio.range%284000000..12000000%29._.Carroceria.sed%C3%A1n.%29'
    arr_title, arr_price = fill_arr_price_and_arr_title(pincers, arr_price, arr_title)

    pincers.goto 'https://chileautos.cl/autos/busqueda?s=60&q=%28And.Tipo.Usado._.TipoVeh%C3%ADculo.Autos%2C%20camionetas%20y%204x4._.Regi%C3%B3n.Metropolitana%20de%20Santiago._.%28C.Marca.Toyota._.Modelo.YARIS.%29_.Ano.range%282011..2018%29._.Precio.range%284000000..12000000%29._.Carroceria.sed%C3%A1n.%29'
    arr_title, arr_price = fill_arr_price_and_arr_title(pincers, arr_price, arr_title)

    pincers.goto 'https://chileautos.cl/autos/busqueda?s=80&q=%28And.Tipo.Usado._.TipoVeh%C3%ADculo.Autos%2C%20camionetas%20y%204x4._.Regi%C3%B3n.Metropolitana%20de%20Santiago._.%28C.Marca.Toyota._.Modelo.YARIS.%29_.Ano.range%282011..2018%29._.Precio.range%284000000..12000000%29._.Carroceria.sed%C3%A1n.%29'
    arr_title, arr_price = fill_arr_price_and_arr_title(pincers, arr_price, arr_title)

    pincers.goto 'https://chileautos.cl/autos/busqueda?s=100&q=%28And.Tipo.Usado._.TipoVeh%C3%ADculo.Autos%2C%20camionetas%20y%204x4._.Regi%C3%B3n.Metropolitana%20de%20Santiago._.%28C.Marca.Toyota._.Modelo.YARIS.%29_.Ano.range%282011..2018%29._.Precio.range%284000000..12000000%29._.Carroceria.sed%C3%A1n.%29'
    arr_title, arr_price = fill_arr_price_and_arr_title(pincers, arr_price, arr_title)


    # puts(arr_title.size)
    # puts(arr_price.size)

    # arr_price.size.times do |i|
    #   puts(arr_price[i].gsub("$ ","").gsub(".","").to_i)
    # end
    # arr_title.size.times do |i|
    #   puts(arr_title[i])
    # end

    return arr_price, arr_title
  end

end

def set_average_prices_per_year(arr_title, arr_price)
  average_prices_per_year = {}
  index_per_year = {}
  (2011..2018).each do |i|
    # puts("Haciendo el arreglo con los indices que contien el año #{i}")

    arr_index=[]
    arr_title.each_with_index do |title, index|

      if title == i.to_s
        arr_index.push(index)
      end

    end

    # puts("Calculado el promedio del año #{i}")
    sum = 0
    arr_index.each do |i|
      # puts("El arreglo es #{arr_index} y el indice es #{i}")
      sum = sum + arr_price[i.to_i].gsub("$ ","").gsub(".","").to_f
      # puts("la suma va en #{sum} ")
    end

    # puts("Agregando el resultado al hash")
    prom = 0
    if not arr_index.size == 0
      # puts("La suma es: #{sum}#{sum.class} y el número de datos es #{arr_index.size}#{arr_index.size.class}")
      prom=sum/arr_index.size.to_f
      average_prices_per_year[i] = prom
      index_per_year[i] = arr_index
    end

  end
  return average_prices_per_year, index_per_year
end

def the_cheapest_car_per_year(index_per_year, arr_price)
  cheapest_car_per_year_index_and_value = {}
  index_per_year.each do |year, array|
    prices_of_the_year = []
    array.each do |index|
      prices_of_the_year = prices_of_the_year.push(arr_price[index])
    end

    cheapest_car_per_year_index_and_value[year] = prices_of_the_year.each_with_index.min

  end

  return cheapest_car_per_year_index_and_value
end


arr_price, arr_title = run_pincers
average_prices_per_year, index_per_year = set_average_prices_per_year(arr_title, arr_price)
cheapest_car_per_year = the_cheapest_car_per_year(index_per_year, arr_price)

# index_per_year.each { |year, array| puts("Para el año #{year} el arreglo es:#{array}")}

puts("-----------------------------------------------------------------------------")
puts("-----------------PRECIO PROMEDIO DEL TOYOTA YARIS POR AÑO--------------------")
puts("-----------------------------------------------------------------------------")
puts('')
average_prices_per_year.each { |year, value| puts("El precio promedio del toyota Yaris de #{year} es: $#{value}")}

puts("")
puts("")
puts("-----------------------------------------------------------------------------")
puts("-----------------TOYOTA YARIS CON MEJOR PRECIO POR MODELO--------------------")
puts("-----------------------------------------------------------------------------")
puts('')
cheapest_car_per_year.each { |year, value| puts("El toyota Yaris más barato modelo #{year} vale: #{value[0]}. Te ahorras $#{average_prices_per_year[year] - value[0].gsub("$ ","").gsub(".","").to_f} con respecto al promedio. Es la publicación número #{(index_per_year[year][value[1]])%20 +1} de la página #{(index_per_year[year][value[1]]/20).to_i + 1 }")}
