const functions = require("firebase-functions");
const stripe = require("stripe")(
    "sk_test_51PlW60P8NBIKG6QOsEoWymVF0NvZ3IWjK7BCWxlcvlWHwkaQYSB0aIIsIdDmY7olTv8yemgAlGgTVTzW4oAqdhmU00nLZeW4A6",
);
exports.generatePaymentLinks = functions.https.onRequest((req, res) => {
  const returnURL = "com.example.nanny_fairy";
  const cancelURL = "com.example.nanny_fairy";

  res.json({ returnURL, cancelURL });
});

exports.stripePaymentIntentRequest = functions.https.onRequest(async (req, res) => {
  try {
    let customerId;

    // Gets the customer who's email id matches the one sent by the client
    const customerList = await stripe.customers.list({
      email: req.body.email,
      limit: 1,
    });

    // Checks the if the customer exists, if not creates a new customer
    if (customerList.data.length !== 0) {
      customerId = customerList.data[0].id;
    } else {
      const customer = await stripe.customers.create({
        name: req.body.name,
        address: {
          line1: req.body.line1,
          postal_code: req.body.postal_code,
          city: req.body.city,
          state: req.body.state,
          country: "NLD",
        },
      });
      customerId = customer.id;
    }

    // Creates a temporary secret key linked with the customer
    const ephemeralKey = await stripe.ephemeralKeys.create(
        {customer: customerId},
        {apiVersion: "2023-10-16"},
    );

    // Creates a new payment intent with amount passed in from the client
    const paymentIntent = await stripe.paymentIntents.create({
      description: "Buying Services",
      shipping: {
        name: req.body.name,
        address: {
          line1: req.body.line1S,
          postal_code: req.body.postal_code,
          city: req.body.city,
          state: req.body.state,
          country: "NLD",
        },
      },
      amount: parseInt(req.body.amount),
      currency: "eur",
      payment_method_types: ["card"],
    });

    res.status(200).send({
      paymentIntent: paymentIntent.client_secret,
      ephemeralKey: ephemeralKey.secret,
      customer: customerId,
      success: true,
    });
  } catch (error) {
    res.status(404).send({success: false, error: error.message});
  }
});