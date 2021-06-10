require_relative 'helpers.rb' # .rb is optional 

name1 = "chocolate egg chicken toast avocado".split(' ')
name2 = "cake pudding muffin marshmallow".split(' ')


10.times do

    dish_name = "#{name1.sample} #{name2.sample}"
    image_url = "https://storcpdkenticomedia.blob.core.windows.net/media/recipemanagementsystem/media/recipe-media-files/recipes/retail/desktopimages/rainbow-cake600x600_2.jpg?ext=.jpg"

    run_sql("insert into dishes (name, image_url) values ('#{dish_name}', '#{image_url}');")

end


# Lee Kum Kee Soy Sauce "https://shop.coles.com.au/wcsstore/Coles-CAS/images/9/4/3/9434699.jpg"
# Double Phoenix Chinese Cooking Wine "https://shop.coles.com.au/wcsstore/Coles-CAS/images/1/3/2/1323322.jpg"

# Bega Crunchy Peanut Butter https://shop.coles.com.au/wcsstore/Coles-CAS/images/1/3/3/133820.jpg
# Promite https://shop.coles.com.au/wcsstore/Coles-CAS/images/2/2/4/224959.jpg

# Maharajah's Choice Pappadam https://shop.coles.com.au/wcsstore/Coles-CAS/images/4/1/9/419448.jpg
# Queen Pure Canadian Maple Syrup https://shop.coles.com.au/wcsstore/Coles-CAS/images/8/8/5/8850122.jpg

# Branston Pickle https://shop.coles.com.au/wcsstore/Coles-CAS/images/1/6/8/1689142.jpg
# Massel Vege Stock https://shop.coles.com.au/wcsstore/Coles-CAS/images/4/4/5/4455476.jpg
# Peanut M&M's https://shop.coles.com.au/wcsstore/Coles-CAS/images/3/8/2/3829548.jpg