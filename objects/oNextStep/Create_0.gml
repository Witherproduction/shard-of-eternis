image_alpha = 1;

// Create Cancel Button
if (!instance_exists(oCancelButton)) {
    // Create on the same layer as oNextStep
    instance_create_layer(x, y, layer, oCancelButton);
}
