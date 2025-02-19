import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/blockform.dart';
import 'package:stoneindia/screen/quickviewimages.dart';
import 'package:stoneindia/widget/commonrow.dart';

class BlockFormQuickView extends StatelessWidget {
  final BlockFormData? blockFormData;

  const BlockFormQuickView({super.key, this.blockFormData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            8.height,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blockFormData!.product_name.validate().capitalizeFirstLetter(),
                  style: boldTextStyle(color: kPrimaryColor, size: 20),
                ),
                24.height,
                Wrap(
                  runSpacing: 8,
                  children: [
                    // CommonRowWidget(title: 'Form ID: ', value: '${blockFormData!.id.validate()}', isMarquee: true),
                    CommonRowWidget(title: 'Form Type: ', value: blockFormData!.form_type!.validate().capitalizeFirstLetter()),
                    CommonRowWidget(title: 'Block Number: ', value: blockFormData!.block_name!.validate()),
                    CommonRowWidget(title: 'Product Name: ', value: blockFormData!.product_name!.validate()),
                    CommonRowWidget(title: 'Category: ', value: blockFormData!.category_name!.validate()),
                    CommonRowWidget(title: 'Slab Type: ', value: blockFormData!.slab_type_name!.validate()),
                    CommonRowWidget(title: "Slab Size: ", value: "${blockFormData!.slab_length.validate()}x${blockFormData!.slab_height.validate()} (In Inch)"),
                    CommonRowWidget(
                      title: 'Slab Thickness: ',
                      value: ' ${blockFormData!.slab_thickness.validate()} (In Cm)',
                    ),
                    CommonRowWidget(
                      title: 'Total Sq ft: ',
                      value: '${((int.parse(blockFormData!.total_slabs.validate()) * int.parse(blockFormData!.slab_length.validate())*int.parse(blockFormData!.slab_height.validate())).toInt()/144).toInt()}',
                    ),
                    CommonRowWidget(title: "Total Slab: ", value: blockFormData!.total_slabs.validate()),
                  ],
                ),
                24.height,
                if (blockFormData!.images.validate().isNotEmpty)
                  const Divider(height: 16),
                if (blockFormData!.images.validate().isNotEmpty) Text('Media', style: boldTextStyle()),
                if (blockFormData!.images.validate().isNotEmpty)
                  Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            QuickViewImagesWidget(blockFormImages: blockFormData!.images).launch(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

                            decoration: boxDecorationDefault(
                              color: kPrimaryColor,
                              boxShadow: defaultBoxShadow(spreadRadius: 0, blurRadius: 0),
                              border: Border.all(color: context.dividerColor),
                            ),
                            child: Row(
                              children: [
                                Text('Check Now', style: boldTextStyle()).expand(),
                                const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                              ],
                            ),
                          ),
                        )
                      ]
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
