CreditCardValidations.add_brand(:discover, {length: [16, 17, 18, 19], prefixes: ["6011", "644", "645", "646", "647", "648", "649", "65"] + ("622126".."622925").to_a})
