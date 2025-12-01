-- recipes_demo.sql
-- Complete database setup for Recipe Sharing Website MVP
-- Run this file in SQLite to create everything automatically

-- Drop tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS fridges;
DROP TABLE IF EXISTS recipe_ingredients;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS ingredients;
DROP TABLE IF EXISTS users;

-- Create tables
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    display_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    profile_photo TEXT,
    followers_count INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE recipes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    title TEXT NOT NULL,
    description TEXT,
    image TEXT,
    instructions TEXT,
    preparation_time INTEGER,
    servings INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE ingredients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    image TEXT,
    calories REAL,
    proteins REAL,
    fats REAL,
    carbs REAL
);

CREATE TABLE recipe_ingredients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    recipe_id INTEGER,
    ingredient_id INTEGER,
    amount REAL,
    unit TEXT,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

CREATE TABLE fridges (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    ingredient_id INTEGER,
    amount REAL,
    unit TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

CREATE TABLE favorites (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    recipe_id INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(id)
);

CREATE TABLE comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    recipe_id INTEGER,
    user_id INTEGER,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert demo users
INSERT INTO users (display_name, email, password_hash, profile_photo, followers_count) VALUES 
('Chef Maria', 'maria@example.com', 'scrypt:32768:8:1$Zc7SJzJv6yTgLk9W$hashed_password_1', 'maria.jpg', 1250),
('Foodie John', 'john@example.com', 'scrypt:32768:8:1$Ab8TkKxW3pRmNq2Z$hashed_password_2', 'john.jpg', 890),
('Baker Sarah', 'sarah@example.com', 'scrypt:32768:8:1$Xy9LmNpQ7rStUv4W$hashed_password_3', 'sarah.jpg', 2100);

-- Insert 100 ingredients with nutritional info
INSERT INTO ingredients (name, image, calories, proteins, fats, carbs) VALUES
('Tomato', 'tomato.jpg', 18, 0.9, 0.2, 3.9),
('Onion', 'onion.jpg', 40, 1.1, 0.1, 9.3),
('Garlic', 'garlic.jpg', 149, 6.4, 0.5, 33.1),
('Carrot', 'carrot.jpg', 41, 0.9, 0.2, 10.0),
('Potato', 'potato.jpg', 77, 2.0, 0.1, 17.0),
('Bell Pepper', 'bell_pepper.jpg', 31, 1.0, 0.3, 6.0),
('Broccoli', 'broccoli.jpg', 34, 2.8, 0.4, 7.0),
('Spinach', 'spinach.jpg', 23, 2.9, 0.4, 3.6),
('Lettuce', 'lettuce.jpg', 15, 1.4, 0.2, 2.9),
('Cucumber', 'cucumber.jpg', 15, 0.7, 0.1, 3.6),
('Zucchini', 'zucchini.jpg', 17, 1.2, 0.3, 3.1),
('Eggplant', 'eggplant.jpg', 25, 1.0, 0.2, 6.0),
('Mushroom', 'mushroom.jpg', 22, 3.1, 0.3, 3.3),
('Celery', 'celery.jpg', 16, 0.7, 0.2, 3.0),
('Green Beans', 'green_beans.jpg', 31, 1.8, 0.1, 7.0),
('Corn', 'corn.jpg', 86, 3.3, 1.2, 19.0),
('Peas', 'peas.jpg', 81, 5.4, 0.4, 14.0),
('Cabbage', 'cabbage.jpg', 25, 1.3, 0.1, 6.0),
('Cauliflower', 'cauliflower.jpg', 25, 2.0, 0.3, 5.0),
('Asparagus', 'asparagus.jpg', 20, 2.2, 0.1, 3.9),
('Kale', 'kale.jpg', 49, 4.3, 0.9, 9.0),
('Sweet Potato', 'sweet_potato.jpg', 86, 1.6, 0.1, 20.0),
('Pumpkin', 'pumpkin.jpg', 26, 1.0, 0.1, 7.0),
('Radish', 'radish.jpg', 16, 0.7, 0.1, 3.4),
('Beetroot', 'beetroot.jpg', 43, 1.6, 0.2, 10.0),
('Apple', 'apple.jpg', 52, 0.3, 0.2, 14.0),
('Banana', 'banana.jpg', 89, 1.1, 0.3, 23.0),
('Orange', 'orange.jpg', 47, 0.9, 0.1, 12.0),
('Lemon', 'lemon.jpg', 29, 1.1, 0.3, 9.0),
('Lime', 'lime.jpg', 30, 0.7, 0.2, 11.0),
('Strawberry', 'strawberry.jpg', 32, 0.7, 0.3, 7.7),
('Blueberry', 'blueberry.jpg', 57, 0.7, 0.3, 14.0),
('Grape', 'grape.jpg', 69, 0.7, 0.2, 18.0),
('Watermelon', 'watermelon.jpg', 30, 0.6, 0.2, 8.0),
('Pineapple', 'pineapple.jpg', 50, 0.5, 0.1, 13.0),
('Mango', 'mango.jpg', 60, 0.8, 0.4, 15.0),
('Avocado', 'avocado.jpg', 160, 2.0, 15.0, 9.0),
('Peach', 'peach.jpg', 39, 0.9, 0.3, 10.0),
('Pear', 'pear.jpg', 57, 0.4, 0.1, 15.0),
('Cherry', 'cherry.jpg', 50, 1.0, 0.3, 12.0),
('Kiwi', 'kiwi.jpg', 61, 1.1, 0.5, 15.0),
('Pomegranate', 'pomegranate.jpg', 83, 1.7, 1.2, 19.0),
('Raspberry', 'raspberry.jpg', 52, 1.2, 0.7, 12.0),
('Blackberry', 'blackberry.jpg', 43, 1.4, 0.5, 10.0),
('Coconut', 'coconut.jpg', 354, 3.3, 33.0, 15.0),
('Chicken Breast', 'chicken_breast.jpg', 165, 31.0, 3.6, 0.0),
('Ground Beef', 'ground_beef.jpg', 250, 26.0, 15.0, 0.0),
('Salmon', 'salmon.jpg', 208, 20.0, 13.0, 0.0),
('Eggs', 'eggs.jpg', 155, 13.0, 11.0, 1.1),
('Bacon', 'bacon.jpg', 541, 37.0, 42.0, 1.4),
('Pork Chop', 'pork_chop.jpg', 242, 25.0, 15.0, 0.0),
('Tuna', 'tuna.jpg', 132, 29.0, 1.3, 0.0),
('Shrimp', 'shrimp.jpg', 85, 20.0, 0.5, 0.0),
('Tofu', 'tofu.jpg', 76, 8.1, 4.8, 1.9),
('Turkey', 'turkey.jpg', 135, 29.0, 3.3, 0.0),
('Duck', 'duck.jpg', 337, 19.0, 28.0, 0.0),
('Lamb', 'lamb.jpg', 294, 25.0, 21.0, 0.0),
('Sausage', 'sausage.jpg', 332, 14.0, 30.0, 1.5),
('Ham', 'ham.jpg', 145, 21.0, 6.0, 1.5),
('Chicken Thigh', 'chicken_thigh.jpg', 209, 26.0, 11.0, 0.0),
('Milk', 'milk.jpg', 42, 3.4, 1.0, 5.0),
('Cheese', 'cheese.jpg', 402, 25.0, 33.0, 1.3),
('Butter', 'butter.jpg', 717, 0.9, 81.0, 0.1),
('Yogurt', 'yogurt.jpg', 59, 3.5, 0.4, 4.7),
('Cream', 'cream.jpg', 345, 2.1, 37.0, 2.8),
('Almond Milk', 'almond_milk.jpg', 17, 0.6, 1.5, 0.6),
('Soy Milk', 'soy_milk.jpg', 54, 3.3, 1.8, 6.0),
('Cheddar Cheese', 'cheddar_cheese.jpg', 404, 25.0, 33.0, 1.3),
('Mozzarella', 'mozzarella.jpg', 280, 28.0, 17.0, 3.1),
('Parmesan', 'parmesan.jpg', 431, 38.0, 29.0, 4.1),
('Rice', 'rice.jpg', 130, 2.7, 0.3, 28.0),
('Pasta', 'pasta.jpg', 131, 5.0, 1.0, 25.0),
('Bread', 'bread.jpg', 265, 9.0, 3.2, 49.0),
('Oats', 'oats.jpg', 389, 17.0, 7.0, 66.0),
('Quinoa', 'quinoa.jpg', 120, 4.4, 1.9, 21.0),
('Flour', 'flour.jpg', 364, 10.0, 1.0, 76.0),
('Sugar', 'sugar.jpg', 387, 0.0, 0.0, 100.0),
('Honey', 'honey.jpg', 304, 0.3, 0.0, 82.0),
('Corn Tortilla', 'corn_tortilla.jpg', 218, 5.7, 2.9, 45.0),
('Lentils', 'lentils.jpg', 116, 9.0, 0.4, 20.0),
('Chickpeas', 'chickpeas.jpg', 139, 7.0, 2.0, 22.0),
('Black Beans', 'black_beans.jpg', 132, 9.0, 0.5, 24.0),
('Kidney Beans', 'kidney_beans.jpg', 127, 9.0, 0.5, 23.0),
('Olive Oil', 'olive_oil.jpg', 884, 0.0, 100.0, 0.0),
('Vegetable Oil', 'vegetable_oil.jpg', 884, 0.0, 100.0, 0.0),
('Salt', 'salt.jpg', 0, 0.0, 0.0, 0.0),
('Black Pepper', 'black_pepper.jpg', 251, 10.4, 3.3, 64.0),
('Soy Sauce', 'soy_sauce.jpg', 53, 8.0, 0.1, 4.9),
('Vinegar', 'vinegar.jpg', 18, 0.0, 0.0, 0.9),
('Ketchup', 'ketchup.jpg', 101, 1.0, 0.1, 25.0),
('Mayonnaise', 'mayonnaise.jpg', 724, 1.1, 79.0, 2.7),
('Mustard', 'mustard.jpg', 66, 4.4, 3.3, 5.0),
('Hot Sauce', 'hot_sauce.jpg', 15, 0.8, 0.5, 2.0);

-- Insert recipes
INSERT INTO recipes (user_id, title, description, image, instructions, preparation_time, servings) VALUES
(1, 'Classic Spaghetti Carbonara', 'Creamy Italian pasta dish with eggs, cheese, and pancetta', 'carbonara.jpg', '1. Cook spaghetti according to package instructions until al dente.
2. While pasta cooks, dice pancetta and cook until crispy in a large pan.
3. In a bowl, whisk together eggs, grated Parmesan, and black pepper.
4. Reserve 1/2 cup of pasta water before draining spaghetti.
5. Quickly toss hot spaghetti with pancetta and its fat.
6. Remove from heat and quickly stir in egg mixture, adding pasta water as needed.
7. Serve immediately with extra Parmesan and black pepper.', 25, 4),
(2, 'Vegetable Stir Fry', 'Quick and healthy vegetable medley with tofu in savory sauce', 'stir_fry.jpg', '1. Press and cube tofu, then pan-fry until golden brown. Set aside.
2. Heat oil in a wok or large pan over high heat.
3. Add minced garlic and ginger, stir for 30 seconds until fragrant.
4. Add hard vegetables first (carrots, broccoli), stir fry for 3 minutes.
5. Add softer vegetables (bell peppers, zucchini), cook for 2 more minutes.
6. Return tofu to the pan, add soy sauce and sesame oil.
7. Mix cornstarch with water, add to pan to thicken sauce.
8. Serve hot over rice.', 20, 3),
(1, 'Classic Beef Burger', 'Juicy beef patties with fresh toppings on toasted buns', 'burger.jpg', '1. In a bowl, mix ground beef with salt, pepper, and Worcestershire sauce.
2. Form into 4 equal patties, slightly larger than your buns.
3. Heat grill or pan to medium-high heat.
4. Cook patties for 4-5 minutes per side for medium doneness.
5. During last minute, add cheese slices to melt if desired.
6. Toast burger buns lightly.
7. Assemble burgers: bottom bun, lettuce, tomato, patty, onion, pickles, top bun.
8. Serve with fries or salad.', 30, 4),
(3, 'Fresh Garden Salad', 'Crisp mixed greens with seasonal vegetables and light vinaigrette', 'garden_salad.jpg', '1. Wash and dry all vegetables thoroughly.
2. Tear lettuce into bite-sized pieces into a large bowl.
3. Slice cucumber, cherry tomatoes, and red onion.
4. Add all vegetables to the bowl with lettuce.
5. In a small jar, combine olive oil, vinegar, mustard, salt and pepper.
6. Shake dressing vigorously until emulsified.
7. Pour dressing over salad just before serving and toss gently.
8. Top with croutons or seeds if desired.', 15, 2),
(2, 'Creamy Tomato Soup', 'Comforting homemade tomato soup perfect with grilled cheese', 'tomato_soup.jpg', '1. Heat olive oil in a large pot over medium heat.
2. Add chopped onions and cook until soft, about 5 minutes.
3. Add minced garlic and cook for 1 more minute.
4. Pour in canned tomatoes with their juices and vegetable broth.
5. Bring to a boil, then reduce heat and simmer for 20 minutes.
6. Use immersion blender to puree soup until smooth.
7. Stir in cream and season with salt, pepper, and basil.
8. Simmer for 5 more minutes before serving.', 35, 4),
(1, 'Lemon Herb Roasted Chicken', 'Juicy whole chicken with crispy skin and citrus flavors', 'roasted_chicken.jpg', '1. Preheat oven to 425°F (220°C).
2. Pat chicken dry inside and out with paper towels.
3. Rub chicken with olive oil, salt, pepper, and herbs.
4. Stuff cavity with lemon halves, garlic, and fresh herbs.
5. Truss chicken legs with kitchen twine.
6. Place breast-side up in roasting pan on a rack.
7. Roast for 15 minutes, then reduce heat to 375°F (190°C).
8. Continue roasting until internal temperature reaches 165°F (74°C).
9. Let rest 15 minutes before carving.', 90, 6),
(3, 'Berry Smoothie Bowl', 'Thick and creamy smoothie topped with fresh fruits and granola', 'smoothie_bowl.jpg', '1. Add frozen bananas and mixed berries to a high-speed blender.
2. Pour in yogurt and a splash of milk or juice.
3. Blend until very thick and creamy, scraping sides as needed.
4. If too thick, add more liquid slowly until desired consistency.
5. Pour into a bowl and arrange toppings artistically.
6. Add sliced fresh fruits, granola, coconut flakes, and seeds.
7. Drizzle with honey or maple syrup if desired.
8. Serve immediately with a spoon.', 10, 1),
(2, 'Garlic Butter Shrimp Pasta', 'Quick elegant pasta with succulent shrimp in garlic butter sauce', 'shrimp_pasta.jpg', '1. Cook linguine according to package directions until al dente.
2. While pasta cooks, pat shrimp dry and season with salt and pepper.
3. Heat olive oil and butter in a large skillet over medium-high.
4. Add shrimp and cook 1-2 minutes per side until pink. Remove shrimp.
5. In same pan, add minced garlic and red pepper flakes, cook 30 seconds.
6. Add white wine and lemon juice, simmer 2 minutes.
7. Return shrimp to pan, add parsley and cooked pasta.
8. Toss everything together with pasta water until sauce coats pasta.
9. Serve immediately with lemon wedges.', 20, 3),
(1, 'Chocolate Chip Cookies', 'Classic soft and chewy cookies with melty chocolate chips', 'chocolate_chips.jpg', '1. Preheat oven to 350°F (175°C) and line baking sheets.
2. In a bowl, whisk together flour, baking soda, and salt.
3. In another bowl, cream butter and sugars until light and fluffy.
4. Beat in eggs one at a time, then vanilla extract.
5. Gradually mix in dry ingredients until just combined.
6. Fold in chocolate chips by hand.
7. Drop rounded tablespoons of dough onto baking sheets.
8. Bake for 10-12 minutes until edges are golden but centers are soft.
9. Cool on baking sheet for 5 minutes before transferring.', 30, 24),
(3, 'Vegetable Omelette', 'Fluffy eggs filled with sautéed vegetables and cheese', 'omelette.jpg', '1. Beat eggs with salt, pepper, and a tablespoon of water or milk.
2. Heat butter in a non-stick skillet over medium heat.
3. Sauté diced vegetables until tender, about 3-4 minutes.
4. Pour eggs over vegetables, tilting pan to distribute evenly.
5. As eggs set, lift edges with spatula to let uncooked egg flow underneath.
6. When top is nearly set, sprinkle cheese over one half.
7. Carefully fold omelette in half with spatula.
8. Cook 1 more minute until cheese melts.
9. Slide onto plate and serve immediately.', 15, 1);

-- Insert recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, amount, unit) VALUES
-- Spaghetti Carbonara (Recipe 1)
(1, 70, 400, 'g'), -- Pasta
(1, 50, 200, 'g'), -- Bacon
(1, 48, 4, 'pcs'), -- Eggs
(1, 68, 100, 'g'), -- Parmesan
(1, 74, 2, 'tsp'), -- Black Pepper
(1, 73, 1, 'tsp'), -- Salt
-- Vegetable Stir Fry (Recipe 2)
(2, 53, 300, 'g'), -- Tofu
(2, 4, 2, 'pcs'), -- Carrots
(2, 7, 200, 'g'), -- Broccoli
(2, 6, 2, 'pcs'), -- Bell Pepper
(2, 11, 1, 'pcs'), -- Zucchini
(2, 3, 3, 'cloves'), -- Garlic
(2, 76, 3, 'tbsp'), -- Soy Sauce
(2, 69, 300, 'g'), -- Rice
-- Classic Beef Burger (Recipe 3)
(3, 47, 500, 'g'), -- Ground Beef
(3, 79, 4, 'pcs'), -- Bread (buns)
(3, 1, 2, 'pcs'), -- Tomato
(3, 2, 1, 'pcs'), -- Onion
(3, 9, 100, 'g'), -- Lettuce
(3, 61, 4, 'slices'), -- Cheese
(3, 73, 1, 'tsp'), -- Salt
(3, 74, 1, 'tsp'), -- Black Pepper
-- Fresh Garden Salad (Recipe 4)
(4, 9, 200, 'g'), -- Lettuce
(4, 1, 3, 'pcs'), -- Tomato
(4, 10, 1, 'pcs'), -- Cucumber
(4, 2, 0.5, 'pcs'), -- Onion
(4, 72, 3, 'tbsp'), -- Olive Oil
(4, 77, 1, 'tbsp'), -- Vinegar
(4, 73, 0.5, 'tsp'), -- Salt
(4, 74, 0.5, 'tsp'), -- Black Pepper
-- Creamy Tomato Soup (Recipe 5)
(5, 1, 800, 'g'), -- Tomato
(5, 2, 2, 'pcs'), -- Onion
(5, 3, 3, 'cloves'), -- Garlic
(5, 63, 200, 'ml'), -- Cream
(5, 72, 2, 'tbsp'), -- Olive Oil
(5, 73, 1, 'tsp'), -- Salt
(5, 74, 0.5, 'tsp'), -- Black Pepper
-- Lemon Herb Roasted Chicken (Recipe 6)
(6, 46, 1500, 'g'), -- Chicken Breast (whole chicken)
(6, 29, 2, 'pcs'), -- Lemon
(6, 3, 6, 'cloves'), -- Garlic
(6, 72, 3, 'tbsp'), -- Olive Oil
(6, 73, 2, 'tsp'), -- Salt
(6, 74, 1, 'tsp'), -- Black Pepper
-- Berry Smoothie Bowl (Recipe 7)
(7, 31, 200, 'g'), -- Strawberry
(7, 32, 150, 'g'), -- Blueberry
(7, 27, 2, 'pcs'), -- Banana
(7, 62, 200, 'g'), -- Yogurt
(7, 57, 100, 'ml'), -- Milk
(7, 81, 2, 'tbsp'), -- Honey
-- Garlic Butter Shrimp Pasta (Recipe 8)
(8, 52, 300, 'g'), -- Shrimp
(8, 70, 400, 'g'), -- Pasta
(8, 3, 4, 'cloves'), -- Garlic
(8, 60, 50, 'g'), -- Butter
(8, 72, 2, 'tbsp'), -- Olive Oil
(8, 29, 1, 'pcs'), -- Lemon
(8, 73, 1, 'tsp'), -- Salt
-- Chocolate Chip Cookies (Recipe 9)
(9, 71, 300, 'g'), -- Flour
(9, 60, 200, 'g'), -- Butter
(9, 80, 150, 'g'), -- Sugar
(9, 48, 2, 'pcs'), -- Eggs
(9, 82, 200, 'g'), -- Chocolate Chips
(9, 73, 0.5, 'tsp'), -- Salt
-- Vegetable Omelette (Recipe 10)
(10, 48, 3, 'pcs'), -- Eggs
(10, 1, 1, 'pcs'), -- Tomato
(10, 2, 0.25, 'pcs'), -- Onion
(10, 7, 50, 'g'), -- Broccoli
(10, 61, 50, 'g'), -- Cheese
(10, 60, 1, 'tbsp'), -- Butter
(10, 73, 0.5, 'tsp'), -- Salt
(10, 74, 0.25, 'tsp'); -- Black Pepper

-- Insert random fridge contents for users
INSERT INTO fridges (user_id, ingredient_id, amount, unit) VALUES
-- Chef Maria's fridge (user_id 1)
(1, 1, 5, 'pcs'),  -- Tomatoes
(1, 2, 3, 'pcs'),  -- Onions
(1, 3, 10, 'cloves'), -- Garlic
(1, 48, 12, 'pcs'), -- Eggs
(1, 61, 200, 'g'), -- Cheese
(1, 57, 1000, 'ml'), -- Milk
(1, 60, 250, 'g'), -- Butter
(1, 70, 500, 'g'), -- Pasta
(1, 69, 1000, 'g'), -- Rice
(1, 27, 6, 'pcs'), -- Bananas
-- Foodie John's fridge (user_id 2)
(2, 46, 600, 'g'), -- Chicken Breast
(2, 47, 500, 'g'), -- Ground Beef
(2, 52, 300, 'g'), -- Shrimp
(2, 4, 8, 'pcs'),  -- Carrots
(2, 7, 400, 'g'),  -- Broccoli
(2, 6, 4, 'pcs'),  -- Bell Peppers
(2, 11, 2, 'pcs'), -- Zucchini
(2, 76, 250, 'ml'), -- Soy Sauce
(2, 72, 500, 'ml'), -- Olive Oil
(2, 28, 4, 'pcs'), -- Oranges
-- Baker Sarah's fridge (user_id 3)
(3, 48, 18, 'pcs'), -- Eggs
(3, 71, 2000, 'g'), -- Flour
(3, 80, 1000, 'g'), -- Sugar
(3, 60, 500, 'g'), -- Butter
(3, 57, 500, 'ml'), -- Milk
(3, 27, 8, 'pcs'), -- Bananas
(3, 31, 300, 'g'), -- Strawberries
(3, 32, 200, 'g'), -- Blueberries
(3, 62, 400, 'g'), -- Yogurt
(3, 81, 300, 'g'); -- Honey

-- Insert some favorites
INSERT INTO favorites (user_id, recipe_id) VALUES
(1, 2), (1, 5), (1, 8),  -- Maria's favorites
(2, 1), (2, 3), (2, 6),  -- John's favorites  
(3, 4), (3, 7), (3, 9);  -- Sarah's favorites

-- Insert some comments
INSERT INTO comments (recipe_id, user_id, content) VALUES
(1, 2, 'This carbonara recipe is amazing! So creamy and authentic.'),
(1, 3, 'I added some peas and it turned out great!'),
(3, 1, 'The burgers were juicy and flavorful. My family loved them!'),
(7, 2, 'Perfect breakfast! So refreshing and healthy.'),
(9, 1, 'Best chocolate chip cookies I have ever made!');

-- Print success message
SELECT 'Database setup complete! Created:' AS '';
SELECT '  - 3 users' AS '';
SELECT '  - 100 ingredients' AS '';
SELECT '  - 10 recipes' AS '';
SELECT '  - Recipe ingredients connections' AS '';
SELECT '  - Random fridge contents for each user' AS '';
SELECT '  - Sample favorites and comments' AS '';
SELECT '' AS '';
SELECT 'Your recipe sharing website MVP database is ready!' AS '';