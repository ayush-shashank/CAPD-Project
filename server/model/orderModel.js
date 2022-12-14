const { Schema, SchemaTypes, default: mongoose } = require("mongoose");

const orderSchema = new Schema({
    customerId: {
        type: SchemaTypes.ObjectId,
        required: true,
    },
    productId: {
        type: SchemaTypes.ObjectId,
        required: true
    },
    productName: {
        type: String,
        required: true
    },
    quantity: {
        type: Number,
        required: true,
        min: 0
    },
    orderAmount: {
        type: Number,
        required: true,
        min: 0
    },
    isActive: {
        type: Boolean,
        default: true
    },
    productImageURL: {
        type: String,
        default: ''
    },
    prescriptionURL: {
        type: String,
        default: ''
    },
}, { timestamps: true });

const orderModel = mongoose.model("Order", orderSchema);

module.exports = orderModel;
