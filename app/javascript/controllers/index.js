// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import AiAssistantController from "./ai_assistant_controller"
application.register("ai-assistant", AiAssistantController)

import SignaturePadController from "./signature_pad_controller"
application.register("signature-pad", SignaturePadController)

import LocationSelectorController from "./location_selector_controller"
application.register("location-selector", LocationSelectorController)

import CategorySelectorController from "./category_selector_controller"
application.register("category-selector", CategorySelectorController)

import RadioSelectorController from "./radio_selector_controller"
application.register("radio-selector", RadioSelectorController)

import EmailPreviewController from "./email_preview_controller"
application.register("email-preview", EmailPreviewController)

import ResendApprovalController from "./resend_approval_controller"
application.register("resend-approval", ResendApprovalController)
