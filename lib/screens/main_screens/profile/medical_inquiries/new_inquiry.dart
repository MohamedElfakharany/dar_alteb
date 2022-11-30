import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class NewInquiryScreen extends StatefulWidget {
  const NewInquiryScreen({Key? key}) : super(key: key);

  @override
  State<NewInquiryScreen> createState() => _NewInquiryScreenState();
}

class _NewInquiryScreenState extends State<NewInquiryScreen> {
  var formKey = GlobalKey<FormState>();
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) async {
        if (state is AppCreateInquirySuccessState) {
          if (state.successModel.status) {
            showToast(msg: LocaleKeys.BtnDone.tr(), state: ToastState.success);
            await AppCubit.get(context).getMedicalInquiries().then((v) {
              Navigator.pop(context);
            });
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.successModel.message),
                );
              },
            );
          }
        }
      },
      builder: (context, state) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        var inquiryImage = AppCubit.get(context).inquiryImage;
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtNewInquiries.tr(),
          ),
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsetsDirectional.only(end: 30.0),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 20.0),
              child: Form(
                key: formKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Center(
                      child: Image.asset(
                        appLogo,
                        height: height * 0.2,
                        width: width * 0.3,
                      ),
                    ),
                    verticalMiniSpace,
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: height *
                            0.15, //when it reach the max it will use scroll
                        // maxWidth: width,
                      ),
                      child: DefaultFormField(
                        controller: messageController,
                        expend: true,
                        onTap: () {},
                        type: TextInputType.multiline,
                        validatedText: LocaleKeys.TxtFieldMessage.tr(),
                        label: LocaleKeys.TxtFieldMessage.tr(),
                        hintText: LocaleKeys.TxtFieldMessage.tr(),
                        height: 200.0,
                        contentPadding: const EdgeInsetsDirectional.only(
                            top: 10.0, start: 20.0, bottom: 10.0),
                      ),
                    ),
                    verticalMiniSpace,
                    InkWell(
                      onTap: () {
                        AppCubit.get(context).getInquiryImage();
                      },
                      child: inquiryImage == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.BtnAddFile.tr(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.bold,
                                    color: mainColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                horizontalSmallSpace,
                                const Icon(
                                  Icons.add_a_photo_outlined,
                                  color: mainLightColor,
                                ),
                              ],
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.file(
                                      inquiryImage,
                                      height: height * 0.5,
                                      width: width * 0.8,
                                      fit: BoxFit.cover,
                                    )),
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 200,
                                  color: whiteColor.withOpacity(0.4),
                                ),
                              ],
                            ),
                    ),
                    verticalMediumSpace,
                    ConditionalBuilder(
                      condition: state is! AppCreateInquiryLoadingState,
                      builder: (context) => GeneralButton(
                        title: LocaleKeys.BtnSend.tr(),
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            AppCubit.get(context).createInquiry(
                              message: messageController.text,
                              file: inquiryImage == null
                                  ? ''
                                  : 'https://hq.orcav.com/assets/${Uri.file(inquiryImage.path).pathSegments.last}',
                            );
                          }
                        },
                      ),
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                    verticalLargeSpace,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
